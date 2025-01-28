## 프로젝트 개요
이 프로젝트는 로컬 PC에서 Vagrant를 이용해 가상 머신을 생성하고, 각 노드에서 K3s를 활용해 간단한 쿠버네티스 클러스터를 구성하기 위한 구성 예시입니다. PC의 사양이 충분히 좋지 않아 부하를 최소화하려고 

마스터 노드는 CPU 2개, 메모리 2GB로 설정했고

워커 노드는 CPU 2개, 메모리 4GB로 설정했습니다.

## 프로젝트 구조 및 스펙
- **Master Node**  
  - CPU: 2  
  - Memory: 2GB  

- **Worker Node (2대)**  
  - CPU: 2  
  - Memory: 4GB  

위와 같은 사양으로 구성되어 있으며, 모든 노드는 Vagrant로 생성됩니다. K3s는 경량 쿠버네티스 배포판으로, 리소스가 넉넉하지 않은 환경에서도 동작이 가능합니다.

## 구현 방법
1. **Vagrantfile**  
   - Ubuntu 기반의 가상 머신 이미지를 사용하며, 마스터 노드 1대와 워커 노드 2대를 생성합니다.  
   - 각각 CPU와 메모리가 위 스펙에 맞게 할당됩니다.

2. **k3s_setup.sh**  
   - 노드에 SSH 접속 후 K3s 설치 과정을 자동화합니다.  
   - 마스터 노드에서 서버를 설치하고 토큰과 IP를 저장합니다.  
   - 워커 노드는 이 토큰과 IP를 활용해 마스터 노드에 조인합니다.

## 클러스터 구성 방법
1. Vagrantfile과 k3s_setup.sh를 프로젝트 디렉터리에 위치시킵니다.  
2. 명령 프롬프트 혹은 PowerShell을 열고 해당 디렉터리로 이동합니다.  
3. `vagrant up` 명령어를 실행해 가상 머신을 생성하고 시작합니다.  
4. 모든 가상 머신이 정상적으로 시작된 후, 마스터와 워커 노드에서 다음 명령으로 스크립트를 실행합니다:  
   ```
   vagrant ssh master -c "sudo /bin/bash /vagrant/k3s_setup.sh"
   vagrant ssh worker1 -c "sudo /bin/bash /vagrant/k3s_setup.sh"
   vagrant ssh worker2 -c "sudo /bin/bash /vagrant/k3s_setup.sh"
   ```
5. 마스터 노드에 접속해 `sudo kubectl get nodes` 을 실행하면, 마스터 노드와 워커 노드들이 정상적으로 쿠버네티스 클러스터에 연결된 것을 확인할 수 있습니다.


## 주의사항

**네트워크 구성**
- VirtualBox의 기본 NAT 네트워크(10.0.2.15)는 통신되지 않을 수 있음
- 호스트 전용 네트워크나 브리지 네트워크 사용을 권장

**마스터 노드 설정**
```bash
# 명시적 IP 설정으로 K3s 설치
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=<호스트전용IP> --advertise-address=<호스트전용IP>" sh -
```

## 호스트 PC에서 클러스터 접근 설정

1. 마스터 노드에서 kubeconfig 파일 복사
```bash
vagrant ssh master -c "sudo cat /etc/rancher/k3s/k3s.yaml" > ~/.kube/config
```

2. kubeconfig 파일의 server 주소를 호스트 전용 네트워크 IP로 수정
```bash
sed -i 's/127.0.0.1/<마스터노드IP>/g' ~/.kube/config
```

3. 연결 확인
```bash
kubectl get nodes
```

```
PS C:\workspace\practice_terraform\init-cluster> kubectl get node
NAME      STATUS   ROLES                  AGE   VERSION
master    Ready    control-plane,master   16m   v1.31.4+k3s1
worker1   Ready    <none>                 90s   v1.31.4+k3s1
worker2   Ready    <none>                 12s   v1.31.4+k3s1
```

이제 호스트 PC에서 직접 클러스터를 관리할 수 있습니다.

