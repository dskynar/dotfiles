# 🔑 Setting Up Your AWS `.pem` Private Key File

Follow these steps to move your downloaded AWS private key into a secure location, set the mandatory filesystem permissions, and use it to SSH into your EC2 instance.

---

### Step 1: Create a Secure SSH Directory
Instead of leaving your `.pem` file sitting in your disorganized `~/Downloads` folder where apps can scan it, it is best practice to store it in a hidden, dedicated SSH directory in your home folder.

Open your terminal and create the directory (if it doesn’t already exist):
```bash
mkdir -p ~/.ssh

```

### Step 2: Move the `.pem` File

Move your downloaded key from your Downloads folder into that secure `.ssh` directory.
*(Replace `your-key.pem` with the actual name of your file).*

```bash
mv ~/Downloads/your-key.pem ~/.ssh/your-key.pem

```

### Step 3: Lock Down File Permissions (Crucial)

By default, downloaded files have permissions that allow other local users or apps to read them. SSH will reject your connection with a `WARNING: UNPROTECTED PRIVATE KEY FILE!` error if you don't fix this.

Run `chmod 400` to make the file **read-only exclusively for you** (the owner):

```bash
chmod 400 ~/.ssh/your-key.pem

```

---

### Step 4: Test the Connection

Now that your key is securely established, you can SSH into your EC2 instance.

Run the following command, substituting your specific EC2 user and Public IP address:

```bash
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

```

> 💡 **Default EC2 Usernames Quick Reference:**
> * **Ubuntu:** `ubuntu`
> * **Amazon Linux 2 / 2023:** `ec2-user`
> * **Debian:** `admin`
> * **CentOS:** `centos`
> 
> 

---

### 🌟 Pro-Tip: Stop Typing the Long SSH Command Every Time

If you don't want to look up your IP address and path to the `.pem` file every time you want to connect to AWS, you can add an alias to your brand-new unified `~/dotfiles/.bashrc` file!

Open your `.bashrc` and add a shortcut at the top:

```bash
alias awsssh="ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP"

```

Once you source your file, you can jump directly onto your AWS cloud server just by typing **`awsssh`**.

```

***

Once you run that `chmod 400` command locally, your key is perfectly locked down and ready for your cloud deployments!

```
