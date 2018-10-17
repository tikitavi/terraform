[all]
# private ips
${connection_strings_master}
${connection_strings_nodes}
${connection_strings_etcd}

# public ips
${public_ip_address_infra}
${public_ip_address_master}
${public_ip_address_workers}

[kube-master]
${list_master}
${public_ip_address_master}


[kube-node]
${list_workers}


[etcd]
${list_infra}


[k8s-cluster:children]
kube-node
kube-master


#[k8s-cluster:vars]
