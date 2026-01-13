Class {
	#name : #GtLValueSerializer,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Support'
}

{ #category : #schema }
GtLValueSerializer class >> classSchema [
	^ NeoJSONSchema new
		json: (NeoJSONObject new
				at: #type put: 'object';
				at: #properties
					put: (NeoJSONObject new
							putStringOrNilSchemaAt: #class;
							putStringOrNilSchemaAt: #superclass;
							putStringSchemaAt: #comment;
							putStringSchemaAt: #package;
							putStringArraySchemaAt: #instanceSlots;
							putStringArraySchemaAt: #classSlots;
							putStringArraySchemaAt: #allInstanceMethods;
							putStringArraySchemaAt: #allClassMethods;
							yourself);
				at: #required put: #(class superclass package);
				yourself)
]

{ #category : #serialization }
GtLValueSerializer >> serializeBinding: aBinding withValue: aBindingValue [
	^ {'name' -> aBinding name.
		'bindingClass' -> aBinding class name asString.
		'value'
			-> (self serializeValue: aBindingValue)}
		asDictionary
]

{ #category : #serialization }
GtLValueSerializer >> serializeClass: aClass [
	^ {'class' -> aClass name.
		'superclass'
			-> (aClass superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]).
		'comment' -> aClass instanceSide gtComment.
		'package' -> aClass package name.
		'instanceSlots' -> aClass slotNames.
		'classSlots' -> aClass class slotNames.
		'allInstanceMethods' -> (aClass methods asArray collect: [ :aMethod | aMethod selector ]).
		'allClassMethods' -> (aClass class methods asArray collect: [ :aMethod | aMethod selector ])} asDictionary
]

{ #category : #serialization }
GtLValueSerializer >> serializeValue: aValue [
	^ {'class' -> aValue class name asString.
		'superclass'
			-> (aValue class superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]).
		"'comment' -> aValue class instanceSide gtComment."
		'package' -> aValue class package name.
		'printString' -> ([(aValue printString escapeCharacter: '''')] on: Error do: [:e | 'Error printing object' ]).
		'allInstanceMethods'
			-> (aValue
					ifNil: [ {} ]
					ifNotNil: [ aValue class methods asArray collect: [ :aMethod | aMethod selector ] ]).
		'instanceSlots'
			-> (aValue class allSlots
					collect: [ :aSlot | 
						| slotValue |
						slotValue := aValue readSlotNamed: aSlot name.
						{'name' -> aSlot name.
							'class' -> slotValue class asString.
							'value' -> (slotValue asString escapeCharacter: '''')} asDictionary ])
					asArray} asDictionary
]

{ #category : #validation }
GtLValueSerializer >> validateClass: aJsonObject [
	| aSchema aValidator |
	aSchema := self class classSchema.
	aValidator := aSchema validator.
	aValidator validate: aJsonObject.
	^ aValidator
]
