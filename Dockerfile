FROM ubuntu
MAINTAINER Nick Ruest <ruestn@gmail.com>

# Get ALL of the dependencies...
RUN echo "\ndeb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libgnutls28-dev gnutls-bin libxml2 libxslt libxml2-dev libxslt-dev debianutils xsltproc curl libcurl3 libcurl3-dev php5-curl php5-curl zlib1g-dev graphicsmagick libmagickwand-dev libapache2-mod-proxy-html libxml2 libxml2-dev php5-curl php-soap php5-xsl libxslt1-dev libxslt1.1 lame libimage-exiftool-perl ffmpeg2theora subversion libleptonica libleptonica-dev md5 libx264-dev x264 libx264-120 avinfo mkvtoolnix libavcodec-extra-53 libfaac-dev libfaac0 libxml2-utils w64codecs libdvdcss2 libopenjpeg2 libopenjpeg-dev libavcodec-extra-52 libavdevice-extra-52 libavfilter-extra-0 libavformat-extra-52 libavutil-extra-49 libpostproc-extra-51 libswscale-extra-0 libavcodec-extra-53 libdc1394-22 libdc1394-22-dev libgsm1 libgsm1-dev libopenjpeg-dev yasm libvpx-dev libvpx1 apache2 apache2.2-common apache2-doc apache2-mpm-prefork apache2-utils libexpat1 ssl-cert libapache2-mod-php5 php5 php5-common php5-gd php5-mysql php5-imap php5-cli php5-cgi libapache2-mod-fcgid apache2-suexec php-pear php-auth php5-mcrypt mcrypt php5-imagick imagemagick libapache2-mod-suphp libruby wget mysql-client mysql-server vim-tiny wget unzip coreutils libmysqlclient-dev libmagickcore-dev libmagickwand-dev ghostscript curl drush stow python-software-properties 
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update
RUN echo "oracle-java6-installer  shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN apt-get -y install oracle-java6-installer
RUN easy_install supervisor

# Setup FFMPEG - /usr/local/stow/ffmpeg-1.1.4
RUN ./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc --enable-x11grab --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libdc1394 --enable-libfaac --enable-libgsm --enable-libmp3lame --enable-libopenjpeg --enable-libschroedinger --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libxvid --prefix=/usr/local/stow/ffmpeg-1.1.4

# Setup Tesseract 3.02.02 - /usr/local/stow/tesseract-ocr-3.02.02

# Setup our enviroment
RUN mkdir /usr/local/fedora
RUN mkdir /usr/local/djatoka

# Setup Harvard's FITS tool
ADD https://fits.googlecode.com/files/fits-0.6.2.zip /tmp/
RUN unzip /tmp/fits-0.6.2.zip -d /opt/
RUN ln -s /opt/fits-0.6.2/fits.sh /usr/bin/

# Setup DJATOKA
RUN cd /tmp
RUN wget http://downloads.sourceforge.net/project/djatoka/djatoka/1.1/adore-djatoka-1.1.tar.gz
RUN tar -xzvf adore-djatoka-1.1.tar.gz
RUN cd adore-djatoka-1.1
RUN mv -v * /usr/local/djatoka
RUN cd /usr/local/djatoka/bin
RUN wget https://gist.github.com/ruebot/7eba022ac0f59a530c86/raw/2ed7e054477083202fd275b3288f7833df3b771f/env.sh
RUN cd /usr/loca/djatoka/dist
RUN cp adore-djatoka.war djatoka.war
RUN cp djatoka.war $FEDORA_HOME/tomcat/webapps

# Setup Fedora GSearch

# Setup Solr

# Setup Drupal
RUN cd /tmp
RUN wget http://ftp.drupal.org/files/projects/drupal-7.22.tar.gz
RUN tar -xzvf drupal-7.22.tar.gz
RUN cd drupal-7.22
RUN mv -v * /var/www
RUN chown -hR www-data:www-data /var/www/
RUN cd /var/www/sites/all/modules
RUN drush pm-download views advanced_help ctools imagemagick token libraries
RUN drush pm-enable views advanced_help ctools imagemagick token libraries

# Fetch Islandora and solution packs
RUN cd /var/www/sites/all/libraries
RUN git clone https://github.com/Islandora/tuque.git
RUN cd /var/www/sites/all/modules
# Don't forget to add the other libraries - IA bookreader, jwplayer, openseadragon
RUN git clone git://github.com/Islandora/islandora.git
RUN git clone git://github.com/Islandora/islandora_solution_pack_audio.git
RUN git clone git://github.com/Islandora/islandora_ocr.git
RUN git clone git://github.com/Islandora/islandora_importer.git
RUN git clone git://github.com/Islandora/islandora_solution_pack_book.git
RUN git clone git://github.com/Islandora/islandora_solr_views.git
RUN git clone git://github.com/Islandora/islandora_solr_search.git
RUN git clone git://github.com/Islandora/islandora_solr_search/islandora_solr_config.git
RUN git clone git://github.com/Islandora/islandora_pathauto.git
RUN git clone git://github.com/Islandora/islandora_paged_content.git
RUN git clone git://github.com/Islandora/islandora_xml_forms.git
RUN git clone git://github.com/Islandora/islandora_jwplayer.git
RUN git clone git://github.com/Islandora/islandora_fits.git
RUN git clone git://github.com/Islandora/islandora_bookmark.git
RUN git clone git://github.com/Islandora/islandora_solution_pack_large_image.git
RUN git clone git://github.com/Islandora/islandora_openseadragon.git
RUN git clone git://github.com/Islandora/islandora_solution_pack_pdf.git
RUN git clone git://github.com/ruebot/islandora_solution_pack_web_archive.git
RUN git clone git://github.com/Islandora/islandora_solution_pack_video.git
RUN git clone git://github.com/Islandora/islandora_marcxml.git
RUN git clone git://github.com/Islandora/islandora_internet_archive_bookreader.git
RUN git clone git://github.com/Islandora/islandora_oai.git
RUN git clone git://github.com/Islandora/islandora_solution_pack_image.git
RUN git clone git://github.com/Islandora/islandora.git
RUN git clone git://github.com/Islandora/islandora_solution_pack_collection.git
RUN git clone git://github.com/Islandora/islandora_batch.git
RUN git clone git://github.com/ruebot/islandora_checksum.git
RUN git clone git://github.com/Islandora/objective_forms.git
RUN git clone git://github.com/Islandora/php_lib.git

# Expose the application's ports:
# 80: Drupal 
# 8080: Fedora and Solr
EXPOSE 80 8080

CMD ["/bin/bash", "/usr/local/fedora/tomcat/bin/startup.sh"]
