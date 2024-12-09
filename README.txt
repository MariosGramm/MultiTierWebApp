Το παρόν project είναι μια Multi-Tier διαδικτυακή εφαρμογή στο AWS μέσω terraform . Η εισερχόμενη κίνηση εισέρχεται στο σύστημα μέσω ενός Application Load Balancer , όπου ο ALB με την σειρά του διανέμει τα αιτήματα των χρηστών στα EC2 instances εντός ενός private subnet . Τα EC2 instances επικοινωνούν με μια RDS για ανταλλαγή δεδομένων , η οποία επίσης φιλοξενείται σε ένα private subnet group . Τέλος , τα EC2 instances χρησιμοποιούν ένα NAT Gateway για να έχουν πρόσβαση στο internet(για τυχόν ενημερώσεις κ.α) , χωρίς όμως να είναι προσβάσιμα ΑΠΟ το internet (για λόγους ασφαλείας).

! Ο Application Load Balancer τρέχει σε public subnet group , οπού στα subnets δεν έχει προσαρτηθεί HTTPS πρωτόκολλο( port 443 ) γιατί χρειάζεται domain . Χρησιμοποιείται μόνο το HTTP πρωτόκολλο ( port 80) .

! Τα EC2 Instances είναι μέρος ενός Auto Scaling Group , το οποίο προσθαφαιρεί instances ανάλογα το φόρτο της εφαρμογής.

! Η παρούσα δομή με το κατάλληλο frontend σχεδιασμό θα μπορούσε να χρησιμοποιηθεί για διαφορές διαδικτυακές εφαρμογές . Για παράδειγμα , σε ένα e - commerce κατάστημα :

Frontend: Οι χρήστες βλέπουν τα προϊόντα και κάνουν αναζητήσεις.
Backend: Το backend επεξεργάζεται τις αναζητήσεις και εμφανίζει τα αποτελέσματα.
Database: Η βάση δεδομένων κρατά τα στοιχεία των προϊόντων και των χρηστών.



The present project is a Multi-Tier web application on AWS using Terraform. Incoming traffic enters the system through an Application Load Balancer, which in turn distributes user requests to EC2 instances within a private subnet. The EC2 instances communicate with an RDS for data exchange, which is also hosted in a private subnet group. Finally, the EC2 instances use a NAT Gateway to access the internet (for updates, etc.), without being accessible FROM the internet (for security reasons).

! The Application Load Balancer operates in a public subnet group, where the subnets do not have the HTTPS protocol (port 443) attached because a domain is required. Only the HTTP protocol (port 80) is used.

! The EC2 instances are part of an Auto Scaling Group, which adds or removes instances depending on the application's load.

! This structure, with the appropriate frontend design, could be used for various web applications. For example, in an e-commerce store:

Frontend: Users browse products and perform searches.
Backend: The backend processes searches and displays results.
Database: The database stores product and user information.







