from allauth.account.adapter import DefaultAccountAdapter

class CustomAccountAdapter(DefaultAccountAdapter):

    def save_user(self, request, user, form, commit=False):
        user = super().save_user(request, user, form, commit)
        user.social_security_number = form.cleaned_data.get('social_security_number')
        user.blood_type = form.cleaned_data.get('blood_type')
        user.date_of_birth = form.cleaned_data.get('date_of_birth')
        user.phone_number = form.cleaned_data.get('phone_number')
        user.save()
        return user

class UnitAccountAdapter(DefaultAccountAdapter):

    def save_user(self, request, user, form, commit=False):
        user = super().save_user(request, user, form, commit)
        user.social_security_number = form.cleaned_data.get('social_security_number')
        user.user_role = form.cleaned_data.get('user_role')
        user.isApproved = False # Until Operator Approves, inactive
        user.save()
        return user
