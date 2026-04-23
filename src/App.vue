<script setup lang="ts"></script>

<template>
  <nav>
    <div class="burger" aria-label="Open navigation">
      <span></span>
      <span></span>
      <span></span>
    </div>

    <div class="menu">
      <ul>
        <li>
          <router-link to="/">Home</router-link>
        </li>
        <li>
          <router-link to="/glsl">glsl</router-link>
        </li>
        <li>
          <router-link to="/tsl">tsl</router-link>
        </li>
      </ul>
    </div>
  </nav>

  <main class="screen">
    <router-view />
  </main>
</template>

<style scoped>
nav {
  position: fixed;
  left: 1rem;
  top: 1rem;
  z-index: 20;
  display: inline-block;
}

.screen {
  position: fixed;
  inset: 0;
  z-index: 0;
  overflow: hidden;
}

.screen router-view {
  display: block;
  width: 100%;
  height: 100%;
}

.burger {
  width: 3rem;
  height: 3rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 0.4rem;
  padding: 0.5rem;
  background: rgba(17, 17, 17, 0.9);
  border-radius: 50%;
  cursor: pointer;
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.25);
}

.burger span {
  display: block;
  width: 1.4rem;
  height: 0.15rem;
  background: #fff;
  border-radius: 999px;
}

.menu {
  position: absolute;
  left: 0;
  top: calc(100% + 0.2rem);
  min-width: 10rem;
  padding: 0.75rem;
  background: rgba(17, 17, 17, 0.95);
  border-radius: 1rem;
  box-shadow: 0 18px 40px rgba(0, 0, 0, 0.2);
  opacity: 0;
  visibility: hidden;
  transform: translateY(-4px);
  transition: opacity 180ms ease, transform 180ms ease, visibility 180ms ease;
  pointer-events: none;
}

nav:hover .menu,
nav:focus-within .menu {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
  pointer-events: auto;
}

.menu ul {
  margin: 0;
  padding: 0;
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.menu li {
  margin: 0;
}

.menu a {
  display: block;
  padding: 0.55rem 0.8rem;
  color: #fff;
  text-decoration: none;
  border-radius: 0.75rem;
  transition: background 150ms ease;
}

.menu a:hover,
.menu a:focus-visible {
  background: rgba(255, 255, 255, 0.08);
}
</style>
