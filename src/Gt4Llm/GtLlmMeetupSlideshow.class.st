Class {
	#name : #GtLlmMeetupSlideshow,
	#superclass : #PrioritySlideshow,
	#category : #'Gt4Llm-Presentations'
}

{ #category : #accessing }
GtLlmMeetupSlideshow >> anActualUseCase: aSlide [
	<gtSlide>
	^ aSlide lepiterPage
		setPriority;
		startPage: (LeDatabase gtBook pageNamed: 'What is GT?')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> gtPage [
	<lePage>
	<gtExample>
	<noTest>
	^ (LePage named: 'What is GT?')
		addSnippet: (LeTextSnippet new
				string: 'Let’s start exploring! A part of GT is Lepiter, a notebook environment. We are in it now.';
				yourself);
		addSnippet: (LePharoSnippet new
				code: 'Color blue';
				yourself);
		yourself
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> orouborosPage: aSlide [
	<gtSlide>
	<text: 'I don’t usually write notes for my presentations, but I did for this slide. Here, you see the code that defines the page we are currently looking at. Yes, it’s self-referential. And it’s fun.'>
	^ aSlide classCoder
		setPriority;
		class: self class;
		expandMethodAt: (self class selectors
				detectIndex: [ :aMethodName | aMethodName = #orouborosPage: ])
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> slidePriorities [
	"Instead of manually setting priorities, just list the slides in order here."

	<gtExample>
	^ #(#title:
		#whatIsGt:
		#whatIsGtPage:
		#orouborousPage:
		#whatIsItActually:
		#anActualUseCase:
		)
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> title: aSlide [
	<gtSlide>
	^ aSlide titleWithFooter
		setPriority;
		titleBottomPadding: 30;
		subtitleBottomPadding: 40;
		titleWithFormat: (self asTitle: 'Software Development with LLMs');
		subtitleWithFormat: (self asTitle: 'in Glamorous Toolkit');
		footerWithFormat: (self asBigText: 'veit.heller@feenk.com')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> whatIsGt: aSlide [
	<gtSlide>
	^ aSlide title
		setPriority;
		titleBottomPadding: 30;
		titleWithFormat: (self asSubtitle: 'What is GT?')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> whatIsGtPage: aSlide [
	<gtSlide>
	^ aSlide lepiterPage
		setPriority;
		startPage: (self db pageNamed: 'What is GT?')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> whatIsItActually: aSlide [
	<gtSlide>
	^ aSlide title
		setPriority;
		titleBottomPadding: 30;
		titleWithFormat: (self asSubtitle: 'Okay, but... What is GT? What is it good for?')
]
