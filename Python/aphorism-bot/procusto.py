from wordpress_xmlrpc import Client, WordPressPost
from wordpress_xmlrpc.methods.posts import NewPost

# Autentication
wp_url = "https://acamadeprocusto.wordpress.com/xmlrpc.php"
wp_username = "LOGIN"
wp_password = "PASS"
wp = Client(wp_url, wp_username, wp_password)

# Post
post = WordPressPost()
post.title = '[BOT] - Hello World!'
post.content = 'Sabedoria, informação e Conhecimento. Não nessa ordem.'
post.post_status = 'publish'
post.terms_names = {
  'post_tag': ['BOT', 'firstpost'],
  'category': ['BOT', 'Reflexão']
}
wp.call(NewPost(post))
