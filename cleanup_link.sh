#!/bin/bash

# 定义你的 OVS 桥
BRIDGES=("br-int" "br_prv")

echo "==== 清理 DOWN / LOWERLAYERDOWN 接口 ===="

# 1. 激活所有桥
for br in "${BRIDGES[@]}"; do
    ip link set "$br" up 2>/dev/null && echo "Bridge $br set UP"
done

# 2. 激活桥上的端口，如果端口状态是 DOWN
for br in "${BRIDGES[@]}"; do
    for port in $(ovs-vsctl list-ports "$br"); do
        state=$(cat /sys/class/net/$port/operstate 2>/dev/null)
        if [[ "$state" == "down" ]]; then
            echo "Bringing up port $port on $br"
            ip link set "$port" up
        fi
    done
done

# 3. 删除残留的 DOWN veth（不删除桥和物理网卡）
for iface in $(ip -o link show | awk -F': ' '{print $2}'); do
    state=$(cat /sys/class/net/$iface/operstate 2>/dev/null)
    if [[ "$state" == "down" ]]; then
        # 不删除 lo 和桥
        if [[ ! "$iface" =~ ^(lo|br-int|br_prv)$ ]]; then
            echo "Deleting residual interface $iface"
            ip link delete "$iface" 2>/dev/null
        fi
    fi
done

echo "==== 清理完成 ===="

