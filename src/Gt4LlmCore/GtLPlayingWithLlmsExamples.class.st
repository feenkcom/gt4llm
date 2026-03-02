"
Examples for {{gtClass:GtLPlayingWithLlms}}.
"
Class {
	#name : #GtLPlayingWithLlmsExamples,
	#superclass : #Object,
	#category : #Gt4LlmCore
}

{ #category : #examples }
GtLPlayingWithLlmsExamples >> slideshow [
	<gtExample>
	<return: #GtPresenterSlideShow>
	| slideshow |
	slideshow := GtLPlayingWithLlms new gtPresenterSlideshow.
	self assert: slideshow slides size equals: GtLPlayingWithLlms new slidePriorities size.
	^ slideshow
]
