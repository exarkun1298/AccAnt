<template>
  <div>
    <div class="text-effect" id="accant-txt">
      <span>A</span>
      <span>c</span>
      <span>c</span>

      <span class="ghost">o</span>
      <span class="ghost">u</span>
      <span class="ghost">n</span>
      <span class="ghost">t</span>

      <span>A</span>
      <span>n</span>
      <span>t</span>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>
/*
    * Letters hover effect
    * https://codepen.io/Vadammt/pen/GxLXqg
    */
/* text-effect styling ... */
.text-effect {
  position: relative;
  top: 50%;
  left: 50%;
  transform: translateX(-50%) translateY(-50%);
  border-bottom: 0;
}

.text-effect span {
  display: inspanne-block;
  float: left;
  font-weight: 700;
  font-size: 2em;
  transition: all 1.5s ease-in-out;
  opacity: 1;
  max-width: 2em;
}

.text-effect span.ghost {
  font-weight: normal;
}

/* Hide when NOT mouse over */
.text-effect span.ghost {
  opacity: 0;
  max-width: 0;
}

/* Show while hover */
.text-effect:hover span.ghost {
  opacity: 1;
  max-width: 2em;
}
</style>
