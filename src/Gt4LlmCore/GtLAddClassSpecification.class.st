Class {
	#name : #GtLAddClassSpecification,
	#superclass : #GtLClassTransformationSpecification,
	#instVars : [
		'newClassName',
		'packageName',
		'slotNames',
		'tagName',
		'supeclassName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLAddClassSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLAddClassSpecification >> newClassName [
	^ newClassName
]

{ #category : #accessing }
GtLAddClassSpecification >> newClassName: anObject [
	newClassName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> newClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #newClassName
]

{ #category : #accessing }
GtLAddClassSpecification >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLAddClassSpecification >> packageName: anObject [
	packageName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> packageNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #packageName
]

{ #category : #accessing }
GtLAddClassSpecification >> slotNames [
	^ slotNames
]

{ #category : #accessing }
GtLAddClassSpecification >> slotNames: anObject [
	slotNames := anObject
]

{ #category : #description }
GtLAddClassSpecification >> slotNamesDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #slotNames
]

{ #category : #accessing }
GtLAddClassSpecification >> supeclassName [
	^ supeclassName
]

{ #category : #accessing }
GtLAddClassSpecification >> supeclassName: anObject [
	supeclassName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> supeclassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #supeclassName
]

{ #category : #accessing }
GtLAddClassSpecification >> tagName [
	^ tagName
]

{ #category : #accessing }
GtLAddClassSpecification >> tagName: anObject [
	tagName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> tagNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #tagName
]
