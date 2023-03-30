
# allow http traffic
resource "google_compute_firewall" "allow-http" {
  name    = "wordpress-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags   = ["http"]
  source_ranges = ["0.0.0.0/0"]
}

# allow https traffic
resource "google_compute_firewall" "allow-https" {
  name    = "wordpress-fw-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags   = ["https"]
  source_ranges = ["0.0.0.0/0"]
}

# allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name    = "wordpress-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"]
}

# allow mysql traffic
resource "google_compute_firewall" "allow-mysql" {
  name    = "wordpress-fw-allow-mysql"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
  target_tags   = ["mysql"]
  source_ranges = ["0.0.0.0/0"]
}


# allow rdp traffic
resource "google_compute_firewall" "allow-rdp" {
  name    = "wordpress-fw-allow-rdp"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags   = ["rdp"]
  source_ranges = ["0.0.0.0/0"]
}

# allow icmp traffic
resource "google_compute_firewall" "allow-icmp" {
  name    = "wordpress-fw-allow-icmp"
  network = google_compute_network.vpc.name
  allow {
    protocol = "icmp"
  }
  target_tags   = ["icmp"]
  source_ranges = ["0.0.0.0/0"]
}

# allow VM to connect to Cloud SQL instance
resource "google_compute_firewall" "allow_sql" {
  name    = "allow-sql"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["0.0.0.0/0"]

}


# allow VM to connect to Cloud SQL instance
resource "google_compute_firewall" "allow_filestore" {
  name    = "allow-all"
  network = google_compute_network.vpc.self_link


  allow {
    protocol = "tcp"
    ports    = ["111", "2049"]
  }

  source_ranges = ["0.0.0.0/0"]

}







