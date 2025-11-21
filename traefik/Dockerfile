# Utiliser l'image officielle de Traefik
FROM traefik:v2.6

# Copier le fichier de configuration Traefik
# COPY traefik.yml /etc/traefik/traefik.yml

# (Optionnel) Copier des certificats TLS, si nécessaire
# COPY certs/ /etc/traefik/certs/

# Exposer les ports nécessaires
EXPOSE 80 443

# Commande par défaut pour démarrer Traefik
ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]
