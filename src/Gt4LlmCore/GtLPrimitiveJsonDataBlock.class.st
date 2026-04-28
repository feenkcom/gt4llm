Class {
	#name : #GtLPrimitiveJsonDataBlock,
	#superclass : #GtLPrimitiveStandaloneJsonBlock,
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveJsonDataBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveJsonDataBlock: self
]

{ #category : #adding }
GtLPrimitiveJsonDataBlock >> addJsonBlock: anotherJsonBlock [
	| commonKeys |
	commonKeys := self keysForMerge 
		intersection: anotherJsonBlock keysForMerge.
	commonKeys ifNotEmpty: [
		Error signal: ('Cannot merge json objects. Common keys found: '
			, commonKeys sorted asCommaString) ].
		
	anotherJsonBlock llmJsonData keysAndValuesDo: [ :aKey :aValue |
		jsonData 
			at: aKey
			ifPresent: [ :existingValue |
				Error signal: 'Key already present: ', aKey asString]
			ifAbsent: [ jsonData  
				at: aKey
				put: aValue ] ]
]

{ #category : #adding }
GtLPrimitiveJsonDataBlock >> addJsonBlock: anotherJsonBlock disabiguatingKeys: allowedDuplicatedKeys [
	| commonKeys notAllowedCommonKeys |
	commonKeys := self keysForMerge 
		intersection: anotherJsonBlock keysForMerge.
	notAllowedCommonKeys := commonKeys copyWithoutAll: allowedDuplicatedKeys.
	notAllowedCommonKeys  ifNotEmpty: [ 
		Error signal: ('Cannot merge json objects. Common keys found: '
			, notAllowedCommonKeys sorted asCommaString)  ].
		
	anotherJsonBlock llmJsonData keysAndValuesDo: [ :aKey :aValue |
		| targetKey |
		targetKey := aKey.
		((jsonData includesKey: aKey) and: [ allowedDuplicatedKeys includes: aKey ]) ifTrue: [
				| newKey |
				newKey := self disambiguateKey: aKey in: jsonData.
				targetKey := newKey ].
		
		jsonData 
			at: targetKey
			ifPresent: [ :existingValue |
				Error signal: 'Key already present: ', targetKey asString ]
			ifAbsent: [ jsonData  
				at: targetKey
				put: aValue ] ]
]

{ #category : #adding }
GtLPrimitiveJsonDataBlock >> disambiguateKey: aKey in: aJsonDictionary [
	| newKey index |
	
	index := 0.
	newKey := aKey.
	[ 
		(index > 100) ifTrue: [
				Error signal: ''].
		index := index + 1.
		newKey := aKey, '_', index asString.
	] doWhileTrue: [
		aJsonDictionary includesKey: newKey ].
	
	^ newKey
]

{ #category : #accessing }
GtLPrimitiveJsonDataBlock >> keysForMerge [
	^self dataKey
		ifNil: [ 
			(self jsonData isDictionary)
				ifTrue: [ self jsonData keys ]
				ifFalse: [ #() ] ] 
		ifNotNil: [
			{self dataKey} ]
]
