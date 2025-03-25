# Create a taint on node01 with key of spray, value of mortein and effect of NoSchedule

# Key = spray
# Value = mortein
# Effect = NoSchedule

controlplane ~ ➜  kubectl taint node node01 spray=mortein:NoSchedule
node/node01 tainted

controlplane ~ ➜  kubectl describe nodes node01 | grep -i taint
Taints:             spray=mortein:NoSchedule
