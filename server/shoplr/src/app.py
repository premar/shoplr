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
        if request.headers['Authorization'] == application.config['API_KEY']:
            data = shoplr_list
            data['identifier'] = 'list'

            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[shoplr_list["id"]]
            collection.insert_one(data)

            resp = jsonify({'message': '201 Created!'})
            resp.status_code = 201
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return 401


@application.route('/v1/item/<string:list_id>/', methods=['POST'])
def new_item(list_id):
    if request.method == 'POST':
        shoplr_item = request.json
        if request.headers['Authorization'] == application.config['API_KEY']:
            data = shoplr_item
            data['identifier'] = 'item'
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_id]
            collection.insert_one(data)
            resp = jsonify({'message': '201 Created!'})
            resp.status_code = 201
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return resp


@application.route('/v1/list/<string:list_id>/', methods=['GET'])
def get_item(list_id):
    if request.method == 'GET':
        if request.headers['Authorization'] == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_id]
            elements = list(collection.find({}, {'_id': False}))

            shopping_list = {}
            items = []

            for element in elements:
                if element["identifier"] == "list":
                    shopping_list = dict(element)
                    del shopping_list["identifier"]
                if element["identifier"] == "item":
                    item = dict(element)
                    del item["identifier"]
                    items.append(item)
            shopping_list['items'] = items
            resp = jsonify(shopping_list)
            resp.status_code = 200
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return resp


@application.route('/v1/list/<string:list_id>/', methods=['DELETE'])
def delete_list(list_id):
    if request.method == 'DELETE':
        if request.headers['Authorization'] == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_id]
            collection.drop()
            resp = jsonify({'message': '204 Deleted!'})
            resp.status_code = 204
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return resp


@application.route('/v1/item/<string:list_id>/<string:item_id>/', methods=['DELETE'])
def delete_item(list_id, item_id):
    if request.method == 'DELETE':
        if request.headers['Authorization'] == application.config['API_KEY']:
            client = MongoClient(application.config["DB_SERVER_URI"])
            db = client[application.config["DB_NAME"]]
            collection = db[list_id]
            collection.remove({'id': item_id})
            resp = jsonify({'message': '204 Deleted!'})
            resp.status_code = 204
            return resp
        else:
            resp = jsonify({'message': '401 Unauthorized!'})
            resp.status_code = 401
            return resp


if __name__ == '__main__':
    application.run()
