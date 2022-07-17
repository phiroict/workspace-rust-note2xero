N2X_VERSION ?= $(shell cd ../.. && bash get_web_version_from_toml.sh)
init:
	minikube start --driver=virtualbox
	minikube dashboard&
create:
	-kubectl delete deployment noted2xero
	kubectl create deployment noted2xero --save-config --image=phiroict/noted2xero_web:$(N2X_VERSION)
service:
	kubectl expose deployment noted2xero --type=LoadBalancer --port=8000
	kubectl get services
	kubectl get deployment noted2xero -o yaml > noted2xero_deployment_generated.yml
apply:
	kubectl set image deployments/noted2xero noted2xero-web-lvxq7=phiroict/noted2xero_web:$(N2X_VERSION)
file:
	kubectl apply -f noted2xero_deployment.yml
file_delete:
	kubectl delete -f noted2xero_deployment.yml
teardown:
	minikube stop
	minikube delete
