"
I am an error result for a method requested in a class that does not define it but inherits it from a superclass. #definingMethodReference names the method that defines it; when the superclass gets the method from a trait, that is the trait method.
"
Class {
	#name : #GtLMissingInheritedMethodDomainObject,
	#superclass : #GtLMissingLocalMethodDomainObject,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingInheritedMethodDomainObject >> reasonDescription [
	^ 'inherited'
]
