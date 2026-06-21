# Module 1: Introduction to Cloud

In this training, we use a coffee shop analogy to help you better understand basic cloud concepts. To explore the coffee shop and learn more about your instructors, choose each of the following four numbered markers.

In our coffee shop example, a barista and customer were used to represent the client-server model. The barista represents the server and a customer represents the client.

Which scenario BEST describes how the client-server model works in this analogy?

The customer goes to the barista and places an order for a coffee. The barista prepares the coffee and hands it back to the customer. This describes how the client places the request, and the server responds.

## What is Cloud Computing?

Cloud computing is essentially the on-demand delivery of IT resources over the internet with pay-as-you-go pricing. Shall we break this down a bit? I think we shall. On demand means you use resources as needed. Let's say your business needs 2,000 TB of storage. Open an AWS account, throw some files into Amazon S3, and Bob’s your uncle. You're good to go. If you don't need to store those files anymore? Delete them, and stop paying immediately.

The idea of the delivery of these on-demand IT resources, as you learned, is the concept that got AWS started in the first place. Let's say you have an application that you have to run, content you need stored, or data you need analyzed. Basically, you have stuff that uses IT resources that have to live and operate somewhere. All of that data is stored in a data center, which is essentially a building or set of buildings devoted to housing servers that contain all this data. Data centers are designed with redundant power, cooling, and security measures to ensure secure and continuous operation. Historically, businesses would run applications in their own data centers or co-locate with other customers in a shared facility. There was no alternative. Once AWS became available, companies could now run their applications in other data centers they didn't actually own. No more infrastructure to manage. No more repetitive tasks and time-consuming ones--goodbye. By using AWS, teams could now focus on innovation.

Oh, and the over-the-internet part means you can access those resources remotely. You can be in your house, place of business, or visiting family around the world. Hi Mom! In fact, all you need is an internet connection. Log into your AWS Account and manage your infrastructure right from your web-browser.

And with pay-as-you-go pricing, if you don’t need a particular part of your infrastructure, just deprovision it. Simple as that. No contracts. No need to call a sales rep.

To reiterate: cloud computing is the on-demand delivery of IT resources over the internet with pay-as-you-go pricing. So, as you tackle the rest of this content, keep this definition in mind. Happy learning!

---

## History of cloud computing and AWS

Before we dive into cloud computing, let's rewind the clock and set some context for how Amazon grew to include Amazon Web Services. In the early 2000s, Amazon.com was an ecommerce site that customers used to buy books and other consumer goods. As more people started to use the site, the Amazon IT team had to continually make upgrades to keep things running smoothly. More servers, more storage, more compute. You name it. They were deploying it!

The team eventually decided to develop various standardized tools, mechanisms, and ways to make things more efficient and scalable. These methods proved to be quite effective, and in 2003, employees thought, "Maybe this knowledge would be valuable to other companies facing similar challenges." Thus, Amazon started to envision a service that would allow businesses to rent computing power, storage, and other resources, on-demand. This business model could eliminate the need for upfront investment in hardware.

Just a year later, in November 2004, AWS launched its first public infrastructure service: Amazon Simple Queue Service. Two years later, AWS launched Amazon Simple Storage Service for data storage and Amazon Elastic Compute Cloud for scalable compute. Initially, AWS was used by smaller start-ups and developers. However, its scalability, cost-effectiveness, and ease of use quickly attracted larger enterprises.

Over the next few years, AWS rapidly expanded its offerings by adding databases, networking, analytics, and many other cloud-based services. Fast forward to the present. AWS powers a significant portion of the internet, serving millions of customers worldwide. From small start-ups and businesses, to large corporations, government agencies, and more. What started as an internal solution for Amazon's own IT needs has grown into a global cloud computing leader.

---

## Cloud deployment types

You can deploy cloud resources in multiple ways: cloud, on-premises, and hybrid. Each type offers unique benefits and considerations, and exploring these options can help you make informed decisions about your cloud strategy. To learn more about cloud deployment types, choose each of the following flashcards.

### Cloud

In a cloud-based deployment model, you have the flexibility to migrate your existing resources to the cloud, design and build new applications within the cloud environment, or use a combination of both.

For instance, a company might migrate data resources to the cloud, then develop an application comprised of virtual servers, databases, and networking components entirely hosted in the cloud.

### ON premises

Deploying resources on premises using virtualization and resource management tools does not provide many of the benefits of cloud computing. However, it is sometimes sought for its ability to provide dedicated resources and low latency.

In most cases this deployment model is the same as legacy IT infrastructure while using application management and virtualization technologies to try increasing resource utilization.

### Hybrid Deployment

In a hybrid deployment, cloud-based resources and on-premises infrastructure work together. This approach is ideal for situations where legacy applications must remain on premises due to maintenance preferences or regulatory requirements.

For instance, a company might choose to retain certain regulated legacy applications on-premises while using cloud services for advanced data processing and analytics.

Multi-cloud deployments can also be considered hybrid deployments.

---

## Benefits of AWS cloud

The six key benefits of the AWS Cloud are as follows.

### 1. Trade fixed expense for variable expense

By using the AWS Cloud, businesses can transition from fixed investments to variable costs. With variable costs, customer expenses are better aligned with actual usage, thus creating more financial flexibility.

### Benefit from massive economies of scale

Like buying a product in bulk can result in lower prices per unit, the vast global infrastructure of AWS can result in lower costs for customers. This means that AWS can be used by many organizations, from small startups to major corporations. Businesses big and small can access advanced technologies that were previously only accessible to large enterprises.

### Stop guessing capacity

Customers can dynamically scale AWS Cloud resources up or down based on real-time demand. This means businesses can achieve optimal performance without provisioning more or less infrastructure than they need.

### Increase speed and agility

With the cloud, businesses can rapidly deploy applications and services, accelerating time to market and facilitating quicker responses to changing business needs and market conditions.

### Stop spending money to run and maintain data centers

The AWS Cloud eliminates the need for businesses to invest in physical data centers. This means customers aren't required to spend time and money on utilities and ongoing maintenance. With AWS taking care of the physical infrastructure of the cloud, customer resources can be reallocated to more strategic initiatives.

### Go global in minutes

Businesses don't need to set up their own infrastructure to expand internationally. AWS provides a robust global infrastructure that customers can use to deploy applications and services across multiple areas in minutes.

### Test

A retail business plans to launch a new line of clothing, but they are struggling with accurately predicting how much server capacity they will need to support the launch.

Which benefit of the AWS Cloud is most relevant to this situation?  
Stop guessing capacity.

---

## Introduction to AWS Global Infrastructure

High Availability

To learn a little bit more about high availability, let's head back to our coffee shop. Say you've hired a new employee, and they're learning how to make a latte. They're doing awesome. They've got the right milk-to-espresso ratio, and they are even making some cool designs with their latte pour—until they miss the cup and they pour the latte all over the register. That is not good. The register is now fried, and it seems like it shorted the electricity everywhere in the shop. Yikes! That means we can't ring up the orders or make drinks for our customers. We're gonna have to close up shop until this is sorted out.

AWS has a similar set up with our global infrastructure. It's risky to have one giant data center where all of the resources are housed. If something were to happen to that data center, like a power outage or a natural disaster, everyone's applications would go down all at once. You need high availability and fault tolerance. Let’s clarify those terms. High availability is all about making sure your applications stay accessible with minimal downtime. Even if one component fails, another is ready to pick up the slack so your service keeps running.

Fault tolerance takes it a step further by designing a system to continue to operate even if multiple components fail. It’s basically building resilience into every layer so that no one single failure brings down the whole system. Designing for high availability and fault tolerance is part of the reason why AWS operates in Regions, which are located in different areas around the world. These Regions are built to be as close to AWS customers as possible. This includes locations like Paris, Tokyo, Sao Paulo, Dublin, or Ohio.

Within each Region, we have what we call Availability Zones, or AZs. There are three or more AZs within a Region, for redundancy. We don't build AZs right next to each other, because if something like a natural disaster were to occur, you could lose connectivity to everything in that AZ. And continuing with the theme of redundancy, within each AZ, there is one or more discrete data centers with redundant power, networking, and connectivity.

So, if a Region is where all the pieces and parts of your application live, some of you might be thinking that we never actually solved the problem that we presented earlier. If my business needs to be disaster proof, then it can't run in just one location. Well, you're absolutely correct. That's why it's common for businesses to operate across multiple Regions. That way, if one Region is experiencing outages for any reason, the operations can failover to another Region...but we'll cover that in more depth in a later lesson.

<img src="../images/screenshots/week5/ha.jpg" width="100%">

---

## The AWS Shared Responsibility Model

The AWS Shared Responsibility Model is a concept designed to help AWS and customers work together to create a secure, functional cloud environment. I

AWS = SECUIRTY OF THE CLOUD

CUSTOMERR = SECURITY IN THE CLOUD

<img src="../images/screenshots/week5/srm1.png" alt="Shared Responsibility model" width="100%">
<img src="../images/screenshots/week5/srm2.png" alt="Shared Responsibility model" width="100%">

You work for a startup company that is developing an application in the cloud. A new security update is available for your operating system (OS), and you are tasked with verifying that the OS is patched accordingly.

Which statement BEST describes which party is responsible for applying security patches to the OS that is running in the cloud?

Your company is responsible applying security patches to the OS.

---

# Module 2: Compute in the Cloud

Compute refers to the processing power needed to run applications, manage data, and perform calculations. In the cloud, this power is available on-demand. You can access it remotely without owning or maintaining physical hardware. Essentially, compute in the cloud means creating virtual machines with a cloud provider to run applications and tasks over the internet. Amazon Elastic Compute Cloud (Amazon EC2), a powerful compute service from AWS, as you explore its flexibility, cost-effectiveness, and scalability.

## Introduction to Amazon EC2

EC2 instances are virtual machines, or VMs. VMs share an underlying physical host machine with multiple other instances, which is a concept called multi-tenancy. In a multi-tenant environment, you need to make sure that each VM is isolated from each other but is still able to share resources provided by the host.

This job of resource sharing and isolation is being done by a piece of software called a hypervisor, which is running on the host machine. For EC2, AWS manages the underlying host, the hypervisor, and the isolation from instance to instance. So, even though you won't be managing this piece, it's important to have a basic grasp of the concept of multi-tenancy.

When you provision an EC2 instance, you can choose the operating system, or OS, based on either Windows or Linux. You can provision thousands of EC2 instances on demand, with a blend of operating systems and configurations to power your business' different applications.

# REFERENCES

https://skillbuilder.aws/learn/94T2BEN85A/aws-cloud-practitioner-essentials/8D79F3AVR7
