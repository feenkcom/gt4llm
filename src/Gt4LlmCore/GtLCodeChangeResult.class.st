Class {
	#name : #GtLCodeChangeResult,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Magritte Objects'
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

{ #category : #testing }
GtLCodeChangeResult >> isClassChangeResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isMethodChangeResult [
	^ false
]
