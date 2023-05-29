#
# Create the required firewall rules
# Firewall rules are VPC wide so only need to be created once. Use a count variable so that the 
# firewall rules are only created when the primary infrastructure is created
#

# allow http traffic
resource "google_compute_firewall" "allow-http" {
  count   = var.primary ? 1 : 0
  name    = "wordpress-fw-allow-http"
  network = data.google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags   = ["http"]
  source_ranges = ["0.0.0.0/0"]
}

# allow https traffic
resource "google_compute_firewall" "allow-https" {
  count   = var.primary ? 1 : 0
  name    = "wordpress-fw-allow-https"
  network = data.google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags   = ["https"]
  source_ranges = ["0.0.0.0/0"]
}

# allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  count   = var.primary ? 1 : 0
  name    = "wordpress-fw-allow-ssh"
  network = data.google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"]
}

# allow mysql traffic
resource "google_compute_firewall" "allow-mysql" {
  count   = var.primary ? 1 : 0
  name    = "wordpress-fw-allow-mysql"
  network = data.google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
  target_tags   = ["mysql"]
  source_ranges = ["0.0.0.0/0"]
}


# allow rdp traffic
resource "google_compute_firewall" "allow-rdp" {
  count   = var.primary ? 1 : 0
  name    = "wordpress-fw-allow-rdp"
  network = data.google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags   = ["rdp"]
  source_ranges = ["0.0.0.0/0"]
}

# allow icmp traffic
resource "google_compute_firewall" "allow-icmp" {
  count   = var.primary ? 1 : 0
  name    = "wordpress-fw-allow-icmp"
  network = data.google_compute_network.vpc.name
  allow {
    protocol = "icmp"
  }
  target_tags   = ["icmp"]
  source_ranges = ["0.0.0.0/0"]
}

# allow VM to connect to Cloud SQL instance
resource "google_compute_firewall" "allow_sql" {
  count   = var.primary ? 1 : 0
  name    = "allow-sql"
  network = data.google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
  # target_tags  = ["mysql"]
  source_ranges = ["0.0.0.0/0"]
}


# allow VM to connect to Cloud SQL instance
resource "google_compute_firewall" "allow_filestore" {
  count   = var.primary ? 1 : 0
  name    = "allow-all"
  network = data.google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["111", "2049"]
  }
  source_ranges = ["0.0.0.0/0"]
}