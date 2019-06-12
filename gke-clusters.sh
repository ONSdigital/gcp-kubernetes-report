#!/usr/bin/env bash -eu

mkdir -p reports
cd reports

output_file=gke-clusters-$(date +%Y-%m-%d-%H-%M-%S).csv
echo "Project,Name,Description,Master Version,Node Version,Node Count,Machine Type,Creation Date,Cluster CIDR,Services CIDR,Status" > "$output_file"

for project_id in $(gcloud projects list --format="value(projectId)" | sort)
do
  cluster_data=$(gcloud container clusters list --format="csv[no-heading](name,\
                                                                          description,\
                                                                          currentMasterVersion,\
                                                                          currentNodeVersion,\
                                                                          currentNodeCount,\
                                                                          nodeConfig.machineType,\
                                                                          createTime,\
                                                                          clusterIpv4Cidr,\
                                                                          servicesIpv4Cidr,\
                                                                          status)" --project="$project_id")

  if [ -n "$cluster_data" ]; then
    echo "$project_id","$cluster_data" >> "$output_file"
  fi
done
