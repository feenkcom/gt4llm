Class {
	#name : #GtLlmObjectSummarizer,
	#superclass : #Object,
	#category : #'Gt4Llm-Summarizer'
}

{ #category : #accessing }
GtLlmObjectSummarizer >> guessPackagePrefixes: aPackage [
	| definedClasses possiblePrefixes amountOfClasses |
	definedClasses := aPackage definedClasses.
	amountOfClasses := definedClasses size.

	amountOfClasses isZero ifTrue: [ ^ #() ].

	possiblePrefixes := ((((definedClasses
			collect: [ :each | each name gtPiecesCutWhereCamelCase ]
			thenSelect: [ :each | each size > 1 ])
			collect: [ :each | each first ] as: Array)
			select: [ :each | (aPackage includesClassNamed: each) not ])
			groupedBy: #yourself) collect: #size.

	possiblePrefixes := possiblePrefixes
			collect: [ :each | (each / amountOfClasses) asFloat ].

	possiblePrefixes := possiblePrefixes associations
			select: [ :each | each key size <= 2 or: [ each value > 0.2 ] ]
			thenCollect: [ :each | each key ].

	^ possiblePrefixes asSet
]

{ #category : #accessing }
GtLlmObjectSummarizer >> shortCollectionName: aCollection on: aStream [
	| aClassName theNamePieces anArticle |
	
	aClassName := aCollection class name.
	theNamePieces := aClassName gtPiecesCutWhereCamelCase.
	anArticle := theNamePieces first first isVowel
		ifTrue: [ 'an' ]
		ifFalse: [ 'a' ].
	
	aStream
		nextPutAll: anArticle;
		space.

	theNamePieces
		do: [ :each | aStream nextPutAll: each asLowercase ]
		separatedBy: [ aStream space ]
]

{ #category : #accessing }
GtLlmObjectSummarizer >> shortPluralClassName: aClass on: aStream [
	| aClassName theNamePieces |
	
	aClassName := aClass name.
	theNamePieces := aClassName gtPiecesCutWhereCamelCase.
	theNamePieces at: theNamePieces size put: (theNamePieces last asEnglishPlural).
	
	theNamePieces
		do: [ :each | aStream nextPutAll: each asLowercase ]
		separatedBy: [ aStream space ]
]

{ #category : #accessing }
GtLlmObjectSummarizer >> summarize: anObject [
	^ String streamContents: [ :aStream | self summarize: anObject on: aStream ]
]

{ #category : #accessing }
GtLlmObjectSummarizer >> summarize: anObject on: aStream [
	self
		summarize: anObject
		on: aStream
		includingSlots: true
		includingInstanceOf: true
]

{ #category : #accessing }
GtLlmObjectSummarizer >> summarize: anObject on: aStream includingSlots: shouldIncludeSlots includingInstanceOf: shouldIncludeAnInstanceOf [
	anObject isCollection
		ifTrue: [ ^ self summarizeCollection: anObject on: aStream ].

	self
		summarizeObject: anObject
		on: aStream
		includingSlots: shouldIncludeSlots
		includingInstanceOf: shouldIncludeAnInstanceOf
]

{ #category : #accessing }
GtLlmObjectSummarizer >> summarizeCollection: aCollection on: aStream [
	| theItemTypes maxItemTypes |
	self shortCollectionName: aCollection on: aStream.

	theItemTypes := (aCollection collect: [ :each |
		each isClass
			ifTrue: [ Class ]
			ifFalse: [ each class ] ] as: Set) asArray
			sorted: [ :a :b | a class name < b class name ].

	theItemTypes ifEmpty: [ ^ self ].

	aStream
		space;
		nextPutAll: 'of';
		space.

	maxItemTypes := 8.
		
	1
		to: (theItemTypes size min: maxItemTypes)
		do: [ :index | 
			(index > 1 and: [ index < theItemTypes size ])
				ifTrue: [ aStream
						nextPut: $,;
						space ].
			(index > 1 and: [ index = theItemTypes size ])
				ifTrue: [ aStream
						space;
						nextPutAll: 'and';
						space ].

			self shortPluralClassName: (theItemTypes at: index) on: aStream ].
	
	theItemTypes size > maxItemTypes
		ifTrue: [ aStream space; nextPutAll: 'and others' ].
]

{ #category : #accessing }
GtLlmObjectSummarizer >> summarizeObject: anObject on: aStream includingSlots: shouldIncludeSlots includingInstanceOf: shouldIncludeAnInstanceOf [
	| aClassName theNamePieces anArticle theSlots |

	aClassName := anObject class name.
	theNamePieces := aClassName gtPiecesCutWhereCamelCase.

	shouldIncludeAnInstanceOf
		ifTrue: [
			aStream
				nextPutAll: 'an instance of';
				space ].
		
	anArticle := theNamePieces first first isVowel
		ifTrue: [ 'an' ]
		ifFalse: [ 'a' ].
	
	aStream
		nextPutAll: anArticle;
		space.

	theNamePieces
		do: [ :each | aStream nextPutAll: each asLowercase ]
		separatedBy: [ aStream space ].
		
	shouldIncludeSlots
		ifFalse: [ ^ self ].

	theSlots := anObject class allSlots.
	theSlots ifEmpty: [ ^ self ].
	
	aStream space; nextPutAll: 'made of'; space.
	
	1
		to: theSlots size
		do: [ :index | 
			| eachSlot |
			(index > 1 and: [ index < theSlots size ])
				ifTrue: [ aStream
						nextPut: $,;
						space ].
			(index > 1 and: [ index = theSlots size ])
				ifTrue: [ aStream
						space;
						nextPutAll: 'and';
						space ].
			
			eachSlot := theSlots at: index.
			
			aStream
				nextPut: $";
				nextPutAll: eachSlot name;
				nextPut: $" ].

	aStream nextPut: $,; space; nextPutAll: 'where'; space.
	
	1
		to: theSlots size
		do: [ :index | 
			| eachSlot |
			(index > 1 and: [ index < theSlots size ])
				ifTrue: [ aStream
						nextPut: $,;
						space ].
			(index > 1 and: [ index = theSlots size ])
				ifTrue: [ aStream
						space;
						nextPutAll: 'and';
						space ].
			
			eachSlot := theSlots at: index.
			
			aStream
				nextPut: $";
				nextPutAll: eachSlot name;
				nextPut: $";
				space;
				nextPutAll: 'is';
				space.

			self
				summarize: (eachSlot read: anObject)
				on: aStream
				includingSlots: false
				includingInstanceOf: false ].
]
