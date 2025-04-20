from django.test import TestCase
from django.contrib.auth.models import User
from .models import Addmoney_info, UserProfile

class AddmoneyInfoModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='testuser', password='testpass')

    def test_default_category_is_food(self):
        addmoney = Addmoney_info.objects.create(
            user=self.user,
            add_money='Expense',
            quantity=1000
        )
        self.assertEqual(addmoney.Category, 'Food')  # Testing default Category

class UserProfileModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='testuser2', password='testpass')
        self.profile = UserProfile.objects.create(
            user=self.user,
            profession='Student',
            Savings=2000,
            income=5000
        )

    def test_userprofile_str_returns_username(self):
        self.assertEqual(str(self.profile), 'testuser2')
