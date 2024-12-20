# [SG per VPC Endpoint](https://github.com/drewpypro/aws-vpce-policy-tester/blob/b162b4bf4f3f611c103794d7f4a4e29470a6a283/module/sg.tf#L1)
![Success](../img/sg4loopmodule.png)

# [Custom Rules per Service](https://github.com/drewpypro/aws-vpce-policy-tester/blob/b162b4bf4f3f611c103794d7f4a4e29470a6a283/module/sg.tf#L15)
![Custom Rules](../img/custom_rules.png)

# [Subnet Validation](https://github.com/drewpypro/aws-vpce-policy-tester/blob/b162b4bf4f3f611c103794d7f4a4e29470a6a283/module/variables.tf#L27)
![Subnet Fail](../img/subnet_fail.png)
- The Terraform plan failed in [run#49](https://github.com/drewpypro/aws-vpce-policy-tester/actions/runs/11849375127/job/33022510919) due to an overly permissive subnet variable introduced in [this commit](https://github.com/drewpypro/aws-vpce-policy-tester/commit/e6c7b0fd80caa5f3d6acf2997b636df361d32cc2).

# [Service Validation](https://github.com/drewpypro/aws-vpce-policy-tester/blob/b162b4bf4f3f611c103794d7f4a4e29470a6a283/module/variables.tf#L7)
![Service Fail](../img/service_fail.png)
- The Terraform plan failed in [run#50](https://github.com/drewpypro/aws-vpce-policy-tester/actions/runs/11850248957/job/33024832642) due to an unauthorized service being supplied to the module introduced in [this commit](https://github.com/drewpypro/aws-vpce-policy-tester/commit/7c472d76f1404911fbc2a11b6acbcc6c325f4e03).
