# Cloud Resume Challenger on Amazon Web Service
> Building my full-stack resume on AWS

This blog is about how I build my resume as website entirely on AWS. This is a challenge created by [Forrest Brazeal](https://twitter.com/forrestbrazeal), Which helped many peoples who wants to step into Cloud technology but doesn't have experience. 

Visit the official [Cloud Resume Challenge](https://cloudresumechallenge.dev) homepage for more information

## Requirement for this challenge
Need to be AWS certified 

✅  AWS Cloud Practitioner certification

✅  AWS Solutions Architect - Associate 


## Lets Start the challenge

### 1. Architecture
First lets start on the papers creating an architecture. Since there are many components involved on this challenge creating a mind map on how things are aligned to build this web-resume.

   ![CRC Architecture](HTML-Webpage/images/CRC-Architecture.png))

I have decided to create my entire stack as IaC and I choose Terraform 

### 2. HTML/CSS 
Wrote my resume as HTML webpage and used CSS for styling. To be honest I am not a web-developer so I took a template from internet and modified it. 

### 3. CI/CD Frontend
Once the HTML code's are ready I decided to implement CI/DC for frontend. I felt this is the most easy part of this challenge.
I used GitHub Actions for my CI/CD pipeline. Once i pushed my codes to GitHub repo, GitHub Actions will be triggered which will sync all my code to a S3 bucket and make it public to access as Static website.

### 4. Domain Registration 
Registered my domain at Porkbun.com 

### 5. Make website functional
Now comes the interesting part. We have our static website and a registered domain. Lets make it work together.

Create a Hosted Zone entry on Route 53 and add records

Create a Cloudfront distribution which will make the website available from all edge location 

One another requirement is our website should always redirect to HTTPS, to make this possible we need to create a certificate on AWS Certificates Manager and connect it to CloudFront. Make sure to have the CloudFront to always redirect to HTTPS.

Voila 💪🏼  our website is online 

### 6. Backend configuration

We are halfway through. Now lets build the backend. Backend consists of **API Gateway**, **Lambda** and **DynamoDB** to store and retrieve visitors count. IMO this is the most challenging task for me since this is the first time am working with API.

I started with DynamoDB, *without basement can't build the building*. I created a table which stores Visitors count, its a simple table with one record. 

Next i created a Lambda function using Python to query DynamoDB to get the Visitors count. This same lambda function would update the visitors count every time the website was accessed. 


![Backend](HTML-Webpage/images/Backend-Arch.png)

### 7. Infrastructure as a Code (IaC)

This is the fun part which I loved to do in this project. Even though the challenge was to use SAM as IaC I decided to use Terraform since am familiar with it. I build the entire stack with Terraform 💯, never configured any of the AWS service via GUI. This helps me understand TF a lot more. 

### 8. CI/CD Pipeline

I went with GitHub actions to automate my workflow. I had two GH repo's one for **Frontend** and another for **Backend**. Each repo had its won GitHub Actions configured. Once I push my code to these repo GH Actions will be triggered based on configuration's.

Front-end Actions will checkout the HTML/CSS codes and sync to S3 bucket

![GitHub Actions Frontend](HTML-Webpage/images/GH-A-Frontend.png)

Back-end Actions consist of two GitHub Actions workflow 
- Terraform Plan
- Terraform Apply

Once I push my code to **FeatureBranch** GH Actions will be triggered and will perform a Terraform Plan, If no errors reported I will merge the FeatureBranch to my Main branch. This will trigger my second GH actions which will perform a Terraform Apply. Thus AWS services are created or modified. 

![Github Actions Backend](HTML-Webpage/images/GH-A-Backend.png)

I configured Terraform Apply job in a such a way that it will trigger only if the code is merged from FeatureBranch to Main branch. 

### 9. Visitor Count

Finally lets play with adding Visitors count to the website.

In this part we need to have a JavaScript on our website which will call the API Gateway, API will trigger the Lambda function which will update the count on DynamoDB and in return GET the visitors count and pass it to the webpage.
This is another tough part for me since JavaScripting is brand new for me.

## Finally!!!

At the end we now have our resume hosted on AWS and its available for the world to access anytime, also we can know how many peoples visited our site 😎

I'm happy that I have completed this challenge as expected. I was able to put all my AWS and Terraform knowledge on this project and am glade to learn something new. 
Eager to do more challenges like this.

Please checkout my website at https://jagan-sekaran.me
source code of [frontend](https://github.com/JAG-010/aws-crc-frontend) and [backend](https://github.com/JAG-010/aws-crc) at [GitHub](https://github.com/JAG-010)
