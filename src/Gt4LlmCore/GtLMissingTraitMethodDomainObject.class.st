"
I am an error result for a method requested in a class that does not define it itself but gets it from a trait. #definingMethodReference names the trait method that defines it.
"
Class {
	#name : #GtLMissingTraitMethodDomainObject,
	#superclass : #GtLMissingLocalMethodDomainObject,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingTraitMethodDomainObject >> reasonDescription [
	^ 'provided by a trait'
]
