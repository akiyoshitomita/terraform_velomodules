# terraform_velomodules

VMware SD-WAN のテスト環境をAzureへ展開するためのTerraform モジュール集

## VMware SD-WAN Edge Deploy with vnet

[VMware SD-WAN By VeloCloud Azure Resource Manager テンプレート](https://github.com/akiyoshitomita/terraform_velomodules/tree/main/modules/edge_vnet)を
ベースとしたEdgeをAzure上に展開するためのモジュールです。


### 利用方法

1. 作業用ディレクトリに下の内容のTFファイル(main.tf)を作成します。
3. activation_keyの値をorchestratorから発行されたアクティベーションキーに上書きを行います。
4. ssh_public_keyの値をsshのパブリックキーの値に変更します
5. [こちらのページ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure)を参考に事前にazurermモジュールの設定を行います。
6. 作業用ディレクトリで `terraform init`コマンドを実行します
7. 作業ディレクトリで`terraform apply`コマンドを実行して環境を構築します。

** 利用するにあたって`git clone`を行う*必要はありません*

```` 
terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
      }
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "t" {
  name     = "velocloud-edge"
  location = "Japan East"
  tags     = local.tags
}

module "edge_net" {
  source = "github.com/akiyoshitomita/terraform_velomodules//modules/edge_vnet"
  resource_group_name = azurerm_resource_group.t.name
  location            = azurerm_resource_group.t.location
  activation_key      = "JN7C-HTPB-XPYR-WV4T"
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhytpuOo4j2a0NsFuOb= userkey"
}
````

## 動作確認バージョン

|name|version|
|-|-|
|terraform| 0.14.2 |
|azurerm|v2.55.0|

## Inputs

|name|説明|Type|省略値|
|-|-|-|-|
|locatoin|ロケーション名|string|japaneast|
|resource_group_name|リソースグループ名|string|(必須)|
|virtual_machine_size|仮想マシンのサイズ|string|Standard_DS3_v2|
|edge_version|デプロイするEdgeのVersion(`Virtual Edge 3.x`or`Virtual Edge 2.5`)|string|Virtual Edge 3.x|
|vco|orchestratorのドメイン名|string|vco301-syd1.velocloud.net|
|ignore_cert_errors|trueの時証明書エラーを無視する|bool|false|
|activation_key|Orchestratorから発行されたEdgeのアクティベーションキー|string|(必須)|
|edge_name|Edgeの名称|string|VeloCloudVirtualEdge|
|ssh_public_key|SSHのパブリックキーの値|string|(必須)|
|vnet_name|Azure Virtual networkの名称|string|AzureVNET|
|vnet_prefix|vnetのプレフィックス|string|172.16.0.0/16|
|public_subnet_name|edgeのWAN側サブネット名|string|public_SN|
|public_subnet|edgeのWAN側のサブネット|string|172.16.0.0/24|
|private_subnet_name|edgeのLAN側サブネット名|string|private_SN|
|private_subnet|edgeのLAN側のサブネット|string|172.16.1.0/24|
|edge_ge3_lanip|edgeのLANインターフェースのIPアドレス|string|172.16.1.4|
|tags|Azureリソースのタグ情報|map(any)|{}|

## Oputputs

無し





