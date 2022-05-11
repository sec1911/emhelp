export default function AuthHeader() {
    const user = JSON.parse(localStorage.getItem('user'));

    if (user) {
        return { Authorization: 'Token ' + user.key };
    } else {
        return {};
    }
}