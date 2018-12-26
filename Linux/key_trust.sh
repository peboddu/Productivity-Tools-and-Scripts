cat ~/.ssh/id_rsa.pub | ssh -4q $@ "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
