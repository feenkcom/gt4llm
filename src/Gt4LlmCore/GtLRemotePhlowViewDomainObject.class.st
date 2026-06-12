Class {
	#name : #GtLRemotePhlowViewDomainObject,
	#superclass : #GtLPhlowViewDomainObject,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #views }
GtLRemotePhlowViewDomainObject >> phlowViewSourceCoder [
	^ (self phlowView definingMethod gtViewCoderFor: GtPhlowView empty) 
			asElementDo: [ :anElement | anElement ]
]
