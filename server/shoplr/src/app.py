from flask import Flask, request, jsonify
from pymongo import MongoClient

application = Flask(__name__, instance_relative_config=True)
application.config.from_pyfile('config.py')


@application.route('/')
def default_route():
    return 'backend of shoplr'


@application.route('/v1/list/', methods=['POST'])
def new_list():
    if request.method == 'POST':
        shoplr_list = request.json
        if shoplr_list['key'] == application.config['API_KEY']:

            data = {
                'identifier': 'meta',
                'name': shoplr_list['name'],
                'icon': shoplr_list['icon']}

            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[shoplr_list["uuid"]]
            collection.insert_one(data)

            resp = jsonify({'message': '201 Created!'})
            resp.status_code = 201
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return 401


@application.route('/v1/item/<string:list_uuid>', methods=['POST'])
def new_item(list_uuid):
    if request.method == 'POST':
        shoplr_item = request.json
        if shoplr_item['key'] == application.config['API_KEY']:
            data = {'identifier': 'item',
                    'uuid': shoplr_item['uuid'],
                    'name': shoplr_item['name'],
                    'specification': shoplr_item['specification'],
                    'icon': shoplr_item['icon'],
                    'expiryDate': shoplr_item['expiryDate']}
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_uuid]
            collection.insert_one(data)
            resp = jsonify({'message': '201 Created!'})
            resp.status_code = 201
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return resp


@application.route('/v1/list/<string:list_uuid>/<string:api_key>', methods=['GET'])
def get_item(list_uuid, api_key):
    if request.method == 'GET':
        if api_key == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_uuid]

            resp = jsonify(list(collection.find({}, {'_id': False})))
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return resp


@application.route('/v1/list/<string:list_uuid>/<string:api_key>', methods=['DELETE'])
def delete_list(list_uuid, api_key):
    if request.method == 'DELETE':
        if api_key == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_uuid]
            collection.drop()
            resp = jsonify({'message': '204 Deleted!'})
            resp.status_code = 204
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return resp


@application.route('/v1/item/<string:list_uuid>/<string:item_uuid>/<string:api_key>', methods=['DELETE'])
def delete_item(list_uuid, item_uuid, api_key):
    if request.method == 'DELETE':
        if api_key == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_uuid]
            collection.remove({'uuid': item_uuid})
            resp = jsonify({'message': '204 Deleted!'})
            resp.status_code = 200
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return resp


if __name__ == '__main__':
    application.run()
