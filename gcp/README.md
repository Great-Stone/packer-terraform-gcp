# Packer-Terraform demo - Terraform

Packer를 통해 GCP상에 Compute Engine을 위한 base image를 기반으로 Compute Engine과 네트워크를 구성합니다.

각 구성요소의 설명은 다음과 같습니다.
- provider.tf
    Terraform 에서 GCP의 프로비저닝을 위한 google 프로바이더 설정
- main.tf
    Terraform의 실행 프로바이더를 통해 GCP상에 네트워크와 VM 구성
- variable.tf
    Terraform 실행 시 변수에 대한 정의