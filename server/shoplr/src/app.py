from flask import Flask, request, jsonify
from pymongo import MongoClient
import json

application = Flask(__name__, instance_relative_config=True)
application.config.from_pyfile('config.py')


@application.route('/')
def default_route():
    return 'backend of shoplr'


@application.route('/v1/list/', methods=['POST'])
def new_list():
    if request.method == 'POST':
        _json = request.json
        shoplr_list = json.loads(_json)
        if shoplr_list['key'] == application.config['API_KEY']:

            data = {'identifier': 'meta', 'name': shoplr_list['name'], 'icon': shoplr_list['icon']}
            json_data = json.dumps(data)

            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[shoplr_list["uuid"]]
            collection.insert_one(json_data)

            resp = "201 Created!"
            resp.status_code = 201
            return resp
        else:
            resp = "401 Unauthorized!"
            resp.status_code = 401
            return 401


@application.route('/v1/article/<string:list_uuid>', methods=['POST'])
def new_article(list_uuid):
    if request.method == 'POST':
        _json = request.json
        shoplr_article = json.loads(_json)
        if shoplr_article['key'] == application.config['API_KEY']:
            data = {'identifier': 'item',
                    'uuid': shoplr_article['uuid'],
                    'name': shoplr_article['name'],
                    'specification': shoplr_article['specification'],
                    'icon': shoplr_article['icon'],
                    'expiryDate': shoplr_article['expiryDate']}
            json_data = json.dumps(data)

            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_uuid]
            collection.insert_one(json_data)

            resp = "201 Created!"
            resp.status_code = 201
            return resp
        else:
            resp = "401 Unauthorized!"
            resp.status_code = 401
            return resp


@application.route('/v1/article/<string:list_uuid>', methods=['GET'])
def get_article(list_uuid):
    if request.method == 'GET':
        _json = request.json
        shoplr_validator = json.loads(_json)
        if shoplr_validator['key'] == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_uuid]
            return list(collection.find({}))
        else:
            resp = "401 Unauthorized!"
            resp.status_code = 401
            return resp


@application.route('/v1/list/<string:list_uuid>', methods=['DELETE'])
def delete_list(list_uuid):
    if request.method == 'DELETE':
        _json = request.json
        shoplr_validator = json.loads(_json)
        if shoplr_validator['key'] == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_uuid]
            collection.drop()
            resp = "200 Deleted!"
            resp.status_code = 200
            return resp
        else:
            resp = "401 Unauthorized!"
            resp.status_code = 401
            return resp


@application.route('/v1/article/<string:list_uuid>/<string:article_uuid>', methods=['DELETE'])
def delete_item(list_uuid, article_uuid):
    if request.method == 'DELETE':
        _json = request.json
        shoplr_validator = json.loads(_json)
        if shoplr_validator['key'] == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_uuid]
            collection.remove({'uuid': article_uuid})
            resp = "200 Deleted!"
            resp.status_code = 200
            return resp
        else:
            resp = "401 Unauthorized!"
            resp.status_code = 401
            return resp


if __name__ == '__main__':
    application.run()
