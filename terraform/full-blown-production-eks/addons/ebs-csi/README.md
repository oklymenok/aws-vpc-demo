# Add EBS CSI driver as AWS managed addon
```
aws eks create-addon --cluster-name simple-eks --addon-name aws-ebs-csi-driver --service-account-role-arn arn:aws:iam::${ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole
```