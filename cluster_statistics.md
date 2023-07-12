# Cluster Node Statistics Script

This Bash script is used to retrieve statistics for nodes in multiple clusters and generate a markdown table with the collected information.

## Prerequisites

Before using this script, make sure you have the following:

1.  Cluster Authentication Files: You need to have the authentication files (`kubeconfig`) for each cluster you want to monitor. The authentication files should be located in the following directories:
    
    -   Cluster 1: `/path/to/auth/cluster1/auth/kubeconfig`
    -   Cluster 2: `/path/to/auth/cluster2/auth/kubeconfig`
    -   Cluster 3: `/path/to/auth/cluster3/auth/kubeconfig`
2.  SSH Access: The script uses SSH to execute commands on each node. Ensure that you have SSH access to the nodes using the specified username (`core`). You may need to configure SSH key-based authentication or provide the password interactively during script execution.
    
3.  Required Tools: The script relies on the following tools being installed and available in the specified paths:
    
- `oc` (OpenShift Command-Line Interface): `/usr/local/bin/oc`

## Instructions

Follow these steps to use the script:

1. Open a terminal.
2. Make sure the authentication files for the clusters are in the correct directories as mentioned in the prerequisites.
3. Copy the script and save it as a Bash file, e.g., `cluster_stats.sh`. 
4. Open the script file in a text editor and modify the script variables if necessary:
    
- `clusters`: Update the array with the correct paths to the authentication files for your clusters.
    
```bash
 clusters=(
    "/path/to/auth/cluster1/auth/kubeconfig"
    "/path/to/auth/cluster2/auth/kubeconfig"
    "/path/to/auth/cluster3/auth/kubeconfig"
)
```

- `OC_PATH`: If the `oc` command-line tool is installed in a different location, update the `OC_PATH` variable accordingly.
- `NODE_USR`: If the SSH username for node access is different from `core`, modify the `NODE_USR` variable.
5. Save the changes to the script file.
6. Make the script file executable by running the following command:

```bash
chmod +x cluster_stats.sh
```

7. Run the script by executing the following command:

```bash
./cluster_stats.sh
```

8. The script will connect to each cluster, retrieve statistics for the nodes, and generate a markdown table with the collected information.

9. The generated table will be displayed in the terminal output. You can copy and paste the table into a markdown file or any other document as needed.

**Note:** The table includes the following columns: Cluster, Node, Total CPU, CPU Used, Total Memory (MB), Memory Used (MB), Total Disk (GB), Disk Used (GB).

## Limitations

- This script assumes that the authentication files (`kubeconfig`) for each cluster are stored in the specified paths. Modify the script if your setup differs.
    
- The script relies on SSH access to the nodes using the specified username (`core`). Make sure you have the necessary SSH access and adjust the `NODE_USR` variable if required.
    
- Ensure that the required tools, such as `oc`, are installed and accessible in the specified paths. Modify the `OC_PATH` variable if the tool is installed in a different location.
    
- The script assumes the clusters are running OpenShift 4.6 or a compatible version. Modify the script if you are using a different version.
    
- The script assumes the clusters are reachable and accessible from the machine running the script.

- _(Optional) If you encounter any issues or errors while running the script, ensure that you have the necessary permissions and dependencies installed correctly. Review the script variables and make sure they are set correctly for your environment._

- Customize the script further if needed or integrate it into your automation workflows as required.
