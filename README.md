# KubeLab

KubeLab은 로컬 환경에서 Kubernetes 기반의 다양한 CNCF(Cloud Native Computing Foundation) 스택을 테스트하고 실험하기 위한 프로젝트입니다.

## 소개

이 프로젝트는 로컬 Kubernetes 클러스터를 기반으로 모니터링, 서비스 메시, CI/CD 등 다양한 CNCF 기술 스택을 테스트하고 학습할 수 있는 환경을 제공합니다. 

개발자와 운영자가 클라우드 네이티브 기술을 쉽게 탐색하고 실험할 수 있도록 구성 중 ... 

## 프로젝트 구조

### Vagrant

[init-cluster](./init-cluster/) 폴더에는 로컬 Kubernetes 클러스터를 쉽게 구축할 수 있는 Vagrant 설정 파일들이 포함되어 있습니다. 자세한 내용은 [README](./init-cluster/README.md) 참고 

### Helm

`helm` 폴더에는 다양한 CNCF 스택들을 Kubernetes 클러스터에 쉽게 배포할 수 있는 Helm 차트들 위치

## 연락처

문의사항이나 제안이 있으시면 이슈를 생성하거나 다음 이메일로 연락 주세요: tlsrid1119@gmail.com