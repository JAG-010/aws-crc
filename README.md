# Cloud Resume Challenge (AWS)

---
1. Certification ✅ 
2. HTML ✅
3. CSS ✅
4. Static S3 Website ✅
5. HTTPS ✅
6. DNS ✅
7. Javascript
8. Database ✅
9. API
10. Python
11. Tests
12. Infrastructure as Code ✅
13. Source Control ✅
14. CI/CD (Back end) ✅
15. CI/CD (Front end) ✅
16. Blog post
    
## Create HTML website of resume

Used template to create a webpage to create my resume added CSS styles to make it look modern.

## Host webpage as a static website on S3

### Reference
https://medium.com/@dblencowe/hosting-a-static-website-on-s3-using-terraform-0-12-aa5ffe4103e
https://www.youtube.com/watch?v=QKyNIdK1RYw
https://gist.github.com/nagelflorian/67060ffaf0e8c6016fa1050b6a4e767a

using terraform to create s3 bucket and made it public 
uploaded HTML and CSS file to bucket and added policy to access publicly 

## Enable HTTPS using cloudfront
https://www.youtube.com/watch?v=lB4DTqMEumY

#### Create a hosted-zone on Route 53
#### Create a SSL certificate
On AWS Certificate manager create a SSL certificate for domain
**Important Use us-east-1**
#### Validate certificate
#### Create CloudFront distribution 
#### Add CF URL to Route 53 HZ 

## Create CI/CD pipeline using Github actions for frontend
Use Github actions to create a pipeline to sync HTML code to S3 bucket whenever there is a code change.

## Create CI/CD pipeline using GH Actions for backend
Use GitHub actions to create a CI/CD pipeline to trigger terraform plan and apply



## Progress
| Date | Milestone |
| --- | --- |
| [8/12/2021] | static website working |
| [8/15/2021] | bought new domain **jagan-sekaran.me** |
| [8/17/2021] | Created SSL certificate and added a Route 53 HZ entry |
|   | Enabled HTTPS on cloudfront |
| [8/18/2021] | **jagan-sekaran.me** URL working |
| [8/18/2021] | Created GitHub actions for frontend |
| [8/24/2021] | Created GitHub Actions for backend |
| [8/25/2021] | Created DynamoDB table |

## << To-Do >>

1. ~~Need to enable remote backend for terraform~~
2. ~~But a domain name~~ 
3. ~~Add domain to **Route 53**~~
4. ~~enable cloudfront~~
5. ~~Add cloudfront domain name to **Route 53**~~
6. ~~Make sure CF is redirecting only to HTTPS~~ 
7. CloudFront cache refresh after CICD pipeline
8. ~~TF apply not working in main branch pull-request~~


## Resource 

### Domain registration
- [Freenom](www.freenom.com) - to register domain for free
- [namesilo](https://www.namesilo.com)
- [porkbun](https://porkbun.com) ✅