#!/bin/bash

clusters=(
    "/path/to/auth/cluster1/auth/kubeconfig"
    "/path/to/auth/cluster2/auth/kubeconfig"
    "/path/to/auth/cluster3/auth/kubeconfig"
)

export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/bin/oc:$PATH"
OC_PATH="/usr/local/bin/oc"
NODE_USR="core"

# Function to get node statistics and generate table row
get_node_statistics() {
    local cluster_name=$1
    local node_name=$2
    local ip=$3

    # Execute the commands via ssh on each node
    sysoutput=$(ssh -q -o "StrictHostKeyChecking no" "$NODE_USR"@"$ip" "
        total_cpu=\$(grep -c '^processor' /proc/cpuinfo)
        used_cpu=\$(top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - \$1}')
        total_memory=\$(grep 'MemTotal' /proc/meminfo | awk '{print \$2 / 1024}')
        used_memory=\$(free -m | awk 'NR==2{print \$3}')
        total_disk=\$(df -h --total | awk 'END{print \$2}' | sed 's/G//')
        used_disk=\$(df -h --total | awk 'END{print \$3}' | sed 's/G//')
        echo \"\$total_cpu,\$used_cpu,\$total_memory,\$used_memory,\$total_disk,\$used_disk\"
    ")

    # Format the statistics as a markdown table row
    row="| $cluster_name | $node_name | $sysoutput |"
    row=$(echo "$row" | sed 's/,/ | /g')
    row=$(echo "$row" | sed 's/^|/| /')
    row=$(echo "$row" | sed 's/|$/ |/')
    echo "$row"
}


# Create the markdown table header
echo "| Cluster | Node | Total CPU | CPU Used | Total Memory (MB) | Memory Used (MB) | Total Disk (GB) | Disk Used (GB) |"
echo "| ------- | ---- | --------- | -------- | ---------------- | ---------------- | --------------- | -------------- |"

# Iterate over clusters
for cluster in "${clusters[@]}"; do
    # Set KUBECONFIG to the cluster's configuration file
    export KUBECONFIG="$cluster"
    # Extract the cluster name from the kubeconfig path
    cluster_name=$(echo "$cluster" | awk -F'/' '{print $(NF-2)}')

    # Run the script for the current cluster
    declare -A node_ips

    # Get node name and IP
    while read -r line; do
        name=$(echo $line | awk '{print $1}')
        ip=$(echo $line | awk '{print $7}')
        node_ips["$name"]=$ip
    done <<< "$($OC_PATH get nodes -o wide | awk 'NR>1{print}')"

    # Iterate over nodes in the current cluster
    for name in "${!node_ips[@]}"; do
        ip="${node_ips[$name]}"
        row=$(get_node_statistics "$cluster_name" "$name" "$ip")
        echo "$row"
    done
done
