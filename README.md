# Sketch Avatar Infrastructure

# Deploy
```bash
terraform apply
```

# Destroy
```bash
terraform destroy
```

# API interaction
```bash
echo '{"key": "some/key/avatar.png"}' | http (terraform output api_url)
http (terraform output api_url)
http (terraform output api_url)/1
```
