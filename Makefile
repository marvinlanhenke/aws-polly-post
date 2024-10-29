INFRA_DIR := infra
FRONTEND_DIR := client
BUCKET_NAME := aws-polly-post-website

.PHONY: frontend-build
frontend-build:
	API_URL=$$(cd $(INFRA_DIR) && terraform output -raw api_url) ; \
	cd $(FRONTEND_DIR) && \
	VITE_API_URL=$$API_URL npm run build

.PHONY: frontend-push
frontend-push:
	aws s3 sync ./client/dist s3://$(BUCKET_NAME)/ --delete

