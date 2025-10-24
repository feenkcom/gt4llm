Class {
	#name : #GtLlmValueSerializer,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #serialization }
GtLlmValueSerializer >> serializeBinding: aBinding withValue: aBindingValue [
	^ {'name' -> aBinding name.
		'bindingClass' -> aBinding class name asString.
		'value'
			-> (self serializeValue: aBindingValue)}
		asDictionary
]

{ #category : #serialization }
GtLlmValueSerializer >> serializeClass: aClass [
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
GtLlmValueSerializer >> serializeValue: aValue [
	^ {'class' -> aValue class name asString.
		'superclass'
			-> (aValue class superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]).
		"'comment' -> aValue class instanceSide gtComment."
		'package' -> aValue class package name.
		'printString' -> (aValue printString escapeCharacter: '''').
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
