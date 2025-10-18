import requests, json
payload={'data':['hello', [], '', 256, 0.6, 0.9, 50, 1.0], 'fn_index':0}
try:
    r=requests.post('http://127.0.0.1:7860/api/predict', json=payload, timeout=120)
    print('STATUS', r.status_code)
    print(r.text)
except Exception as e:
    print('ERROR', e)
    raise