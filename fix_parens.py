with open('lib/screens/abc_wizard_screen.dart', 'r') as f:
    content = f.read()

old_pattern = 'size: 28)))))),'
new_pattern = 'size: 28))))))),
'
content = content.replace(old_pattern, new_pattern)

with open('lib/screens/abc_wizard_screen.dart', 'w') as f:
    f.write(content)
    
print('Fixed')
