docker network create --subnet=172.10.0.0/16 mynetwork
docker network ls

// 用Dockerfile构建centos:consul-1.4.3

// 创建5个容器(name和ip对应，从2开始)
docker run -itd --name test2 --network mynetwork -P --ip 172.10.0.2 --rm centos:consul-1.4.3
docker run -itd --name test3 --network mynetwork --ip 172.10.0.3 --rm centos:consul-1.4.3
docker run -itd --name test4 --network mynetwork --ip 172.10.0.4 --rm centos:consul-1.4.3
docker run -itd --name test5 --network mynetwork --ip 172.10.0.5 --rm centos:consul-1.4.3
docker run -itd --name test6 --network mynetwork --ip 172.10.0.6 --rm centos:consul-1.4.3

// 确认
docker ps -a

// test2
docker exec -it test2 bash
consul agent -server -ui -node=server2 -bootstrap-expect=4 -bind=172.10.0.2 -data-dir /consul/data -config-dir /consul/config -join=172.10.0.2 -client 0.0.0.0

// test3
docker exec -it test3 bash
consul agent -server -node server3 -bootstrap-expect=4 -bind=172.10.0.3 -data-dir=/consul/data -config-dir=/consul/config -join=172.10.0.2

// test4
docker exec -it test4 bash
consul agent -server -node server4 -bootstrap-expect=4 -bind=172.10.0.4 -data-dir=/consul/data -config-dir=/consul/config -join=172.10.0.2

// test5
docker exec -it test5 bash
consul agent -server -node server5 -bootstrap-expect=4 -bind=172.10.0.5 -data-dir=/consul/data -config-dir=/consul/config -join=172.10.0.2

// test6
docker exec -it test6 bash
consul agent -server -node server6 -bootstrap-expect=4 -bind=172.10.0.6 -data-dir=/consul/data -config-dir=/consul/config -join=172.10.0.2

// 查看test2映射的端口
docker port test2

// 访问 test2 web 界面
http://127.0.0.1:[映射的端口]/ui/

// 加入 client 节点
docker run -itd --name test7 --network mynetwork --ip 172.10.0.7 --rm centos:consul-1.4.3 &&
docker run -itd --name test8 --network mynetwork --ip 172.10.0.8 --rm centos:consul-1.4.3 &&
docker run -itd --name test9 --network mynetwork --ip 172.10.0.9 --rm centos:consul-1.4.3

docker exec -it test7 bash
consul agent -node node7 -bind=172.10.0.7 -data-dir=/consul/data -config-dir=/consul/config -join=172.10.0.2

docker exec -it test8 bash
consul agent -node node8 -bind=172.10.0.8 -data-dir=/consul/data -config-dir=/consul/config -join=172.10.0.2

docker exec -it test9 bash
consul agent -node node9 -bind=172.10.0.9 -data-dir=/consul/data -config-dir=/consul/config -join=172.10.0.2

// 访问 test2 web 界面
http://127.0.0.1:[映射的端口]/ui/
