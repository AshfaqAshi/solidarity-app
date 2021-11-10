class Field{
  String name;
  String type;
  var value;
  Field(this.name,this.type, {this.value});

  Field.fromMap(var data):
  this.name=data['name'],
  this.type=data['type']{
    this.value=data['value'];
  }

  toMap(){
    return {
      'type':this.type,
      'name':this.name,
      if(this.value!=null)
        'value':this.value
    };
  }
}

class FieldTypes{
  static const String TEXT='text';
  static const String TEXT_AREA='textarea';
}