namespace:
	kubectl apply -f 01-namespace.yaml
all:
	kubectl apply -f 02-deployment-xero-web.yaml
	kubectl apply -f 03-deployment-xero-frontend.yaml 
	kubectl apply -f 04-service-xero-frontend.yaml
	kubectl apply -f 05-service-xero-web.yaml
	kubectl apply -f 06-ingress-xero-frontend.yaml
delete_all:
	kubectl delete -f 06-ingress-xero-frontend.yaml
	kubectl delete -f 05-service-xero-web.yaml
	kubectl delete -f 04-service-xero-frontend.yaml	
	kubectl delete -f 03-deployment-xero-frontend.yaml 
	kubectl delete -f 02-deployment-xero-web.yaml
	
	
	
	

