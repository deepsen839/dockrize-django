from django.core.management.base import BaseCommand
from django.utils import timezone
from django.contrib.auth.models import User

class Command(BaseCommand):
    help = 'Creates an admin user'

    def handle(self, *args, **kwargs):
        if not User.objects.filter(username='admin').exists():
            User.objects.create_superuser(username='admin',
                password='admin',
                email='admin@example.com')
            self.stdout.write("Admin user created")
        else:
            self.stdout.write("Admin user already exists")
        
        time = timezone.now().strftime('%X')
        self.stdout.write("It's now %s" % time)
