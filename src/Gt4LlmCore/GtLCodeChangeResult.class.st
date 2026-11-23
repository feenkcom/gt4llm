Class {
	#name : #GtLCodeChangeResult,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'accessing - icons' }
GtLCodeChangeResult class >> additionIcon [
	^ self iconNamed: #changeAdd
]

{ #category : #'accessing - icons' }
GtLCodeChangeResult class >> modificationIcon [
	^ self iconNamed: #changeUpdate
]

{ #category : #'accessing - icons' }
GtLCodeChangeResult class >> removalIcon [
	^ self iconNamed: #changeRemove
]

{ #category : #accessing }
GtLCodeChangeResult >> addedVariableNamesFor: aVariableType [
	^ #()
]

{ #category : #testing }
GtLCodeChangeResult >> isClassChangeResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isClassModificationResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isClassRemovalResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isErrorDomainObject [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isMethodChangeResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isVariableAdditionResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isVariableRemovalResult [
	^ false
]

{ #category : #accessing }
GtLCodeChangeResult >> removedVariableNamesFor: aVariableType [
	^ #()
]
