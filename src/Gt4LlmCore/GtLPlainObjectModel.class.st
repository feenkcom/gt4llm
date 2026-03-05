Class {
	#name : #GtLPlainObjectModel,
	#superclass : #GtLWrappedModel,
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLPlainObjectModel >> addContentOneLineSummaryTo: aWriteStream [
	| aString |
	aString := [ model printString ]
			on: Error
			do: [ :e | e return: model className ].
	aWriteStream
		nextPutAll: 'Object: ';
		nextPutAll: aString asString
]

{ #category : #'as yet unclassified' }
GtLPlainObjectModel >> addContentTo: aDictionary [
	aDictionary
		at: name
		put: {'class' -> model class name asString.
				'superclass'
					-> (model class superclass
							ifNil: [ nil ]
							ifNotNil: [ :aSuperclass | aSuperclass name ]).
				'package' -> model class package name.
				'printString'
					-> ([ model printString escapeCharacter: '''' ]
							on: Error
							do: [ :e | 'Error printing object' ]).
				'allInstanceMethods'
					-> (model
							ifNil: [ {} ]
							ifNotNil: [ model class methods asArray collect: [ :aMethod | aMethod selector ] ]).
				'instanceSlots'
					-> (model class allSlots
							collect: [ :aSlot | 
								| slotValue |
								slotValue := model readSlotNamed: aSlot name.
								{'name' -> aSlot name.
									'class' -> slotValue class asString.
									'value' -> (slotValue asString escapeCharacter: '''')} asDictionary ])
							asArray} asDictionary
]

{ #category : #'as yet unclassified' }
GtLPlainObjectModel >> addInstructionsTo: aMessageInstructions [

	aMessageInstructions
		addSection: (GtLInstructionSection new
				source: self;
				title: self name;
				body: '')
]
