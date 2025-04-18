Class {
	#name : #GtLlmValueSerializer,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmValueSerializer >> serializeBinding: aBinding withValue: aBindingValue [
	^ {'name' -> aBinding name.
		'bindingClass' -> aBinding class name asString.
		'value'
			-> (self serializeValue: aBindingValue)}
		asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmValueSerializer >> serializeValue: aValue [
	^ {'class' -> aValue class name asString.
		'string' -> aValue asString.
		'instanceSlots'
			-> (aValue class allSlots
					collect: [ :aSlot | 
						| slotValue |
						slotValue := aValue readSlotNamed: aSlot name.
						{'name' -> aSlot name.
							'class' -> slotValue class asString.
							'value' -> slotValue asString} asDictionary ]) asArray} asDictionary
]
