/* default dom id (particles-js) */
//particlesJS();

/* config dom id */
//particlesJS('dom-id');

/* config dom id (optional) + config particles params */
particlesJS('particles-js', {
  particles: {
				color: "#fff",
				shape: "circle",
				opacity: 0.6,
				size: 1,
				size_random: !0,
				nb: 200,
				line_linked: {
					enable_auto: !0,
					distance: 100,
					color: "#fff",
					opacity: .5,
					width: 1,
					condensed_mode: {
						enable: !1,
						rotateX: 600,
						rotateY: 600
					}
				},
				anim: {
					enable: !0,
					speed: 2.5
				}
			},
  interactivity: {
				enable: !0,
				mouse: {
					distance: 250
				},
				detect_on: "canvas",
				mode: "grab",
				line_linked: {
					opacity: .35
				},
				events: {
					onclick: {
						enable: !0,
						mode: "push",
						nb: 3
					}
				}
			},
  /* Retina Display Support */
  retina_detect: true
});